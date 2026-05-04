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
    fdecls: (fname * ((tp list) * tp)) list;
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

let rec look2 (env : (fname * ((tp list) * tp)) list) (var : fname) = match env with 
          |[] -> None
          |(f,tl)::l -> if f = var then (Some tl) else ( look2 l var );;

let rec total (liste :bool list) = match liste with |[] -> true | a::m -> if (a) then total (m) else false
let rec appartient (liste : base_tp list) (element : base_tp)  = match liste with
  |[] -> false
  |a::l -> if ((element = a) || (element = IntT && a = FloatT) || (element  = BoolT && (a = IntT || a = FloatT))) then true else appartient (l) (element) ;;

let inclu (expression: tp) (general : tp) = total (let UnionT(m) = expression in let UnionT(l) = general in (List.map (appartient (l)) (m)))


exception Variable_inexistante;;
exception Erreur_type;;
exception Fonction_non_def;;
exception Argument_incorect;;

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
              |CallE (v,l) -> let looking = (look2 env.fdecls v) in (match looking with
	                                        |None -> raise Fonction_non_def
	                                        |Some (tplist, tpretour) -> if (inclu2 (List.map tp_expr l) (tplist)) then tpretour else raise Argument_incorect)

exception Code_inatteignable
exception Variable_pas_instancie
exception Fonction_mal_def

let rec etape ((env, retour, returnn) : (environment * tp * bool)) liste = match liste with 
          |[] -> (env, retour, returnn)
          |stm::l -> etape (tp_stmt stm) (l) ;;


let rec replace (env : (vname * tp) list) (var : vname) (typ : expr) : environment -> match env with
              |[] -> []
              |(name,typp)::l -> if name = var then [(var,(tp_expr typ))]::replace  else [(name,typp)]::replace l var typ

let rec tp_stmt ((env, t, returned) : (environment * tp * bool)) stm : (environment * tp * bool) = match (stm,returned) with 
              | (_,true) -> raise Code_inatteignable
              | (Block l,false) -> (etape (env, t, returned) (l))
              | (Assign (v,ex),false) -> let tipe = let looking = (look env.static_vars.locals v) in (match looking with
	                                        |None -> (let looking2 = (look env.static_vars.globals v) in (match looking2 with
	                                                |None -> raise Variable_inexistante 
	                                                |Some t -> t ))
	                                        |Some t -> t )  
                                       in if inclu (tp_expr ex) (tipe) then let globa = (replace env.dyn_vars.globals v ex) and loca = (replace env.dyn_vars.locals v ex) in  else raise Variable_pas_instancie 
              |
              |Return (expre) -> (env, (tp_expr expre), true)
              |CallS (vn, explist) -> let looking = (look2 env.fdecls vn) in (match looking with
	                                        |None -> raise Fonction_non_def
	                                        |Some (tplist, tpretour) -> if (inclu2 (List.map (tp_expr) (explist)) (tplist)) then (env, t, returned) else raise Argument_incorect)
              |_ -> Printf.printf"type inconnu \n";true

			


let tp_fundefn (env_init : environment) (funn : (fundecl * (vardecl list) * stmt)) = let (f, vds, s ) =funn in let (fn, pards, rt) = f in let retour = (tp_stmt (env_init) (s) ) in (inclu retour rt);;

  (* Function declarations of library / predefined functions *)
let library_fds = [
    ("input", ([UnionT[StringT]], UnionT[StringT]))
  ; ("int",   ([UnionT[BoolT; FloatT; IntT; StringT]], UnionT[IntT]))
  ; ("print", ([UnionT[StringT]], UnionT[NoneT]))
  ; ("str",   ([UnionT[BoolT; FloatT; IntT; StringT]], UnionT[StringT]))
  ]

let maj_env_fonc (list_fonc : fundefn list) = match list_fonc with 
                  |[] -> []
                  |((Fundecl(fn, pards, rt), vds, s))::reste ->let init_env = 
                                {fdecls = [] @ library_fds; static_vars = { globals = []; locals = pards @ vds }; dyn_vars = { globals = []; locals = pards @ vds}; curfun = None } 
                              in
                                if duplicate_free (List.map fst init_env.static_vars.locals) && (tp_fundefn (init_env) ((Fundecl(fn, pards, rt), vds, s))) 
                                    then [(fn,pards,rt)]::maj_env_fonc (reste)
                                    else raise Fonction_mal_def
                   

(* The following has to be defined in detail *)
let tp_prog (Prog(fdefns, vds, s)) = 
  let fds = (maj_env_fonc fdefns) in
  let globs = vds in
  let init_venv = { globals = globs; locals = [] } in 
  let init_env = 
    { fdecls = fds @ library_fds; static_vars = init_venv; dyn_vars = init_venv; curfun = None } in
  if duplicate_free (List.map fst fds) 
    && duplicate_free (List.map fst globs) 
  && List.for_all (tp_fundefn init_env) fdefns
  then tp_stmt (init_env, UnionT[NoneT], false) s
  else failwith "duplicate function or variable declarations";;
