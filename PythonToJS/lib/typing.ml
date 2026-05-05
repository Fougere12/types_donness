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

let rec union (t : tp) (g : tp) : tp = let UnionT(l) = t and UnionT(m) = g in match l with 
              |[] -> UnionT(m)
              |a::l -> if appartient (m) (a) then union (UnionT(l)) (g) else union (UnionT(l)) (UnionT([a]@m))

let inclu (expression: tp) (general : tp) = total (let UnionT(m) = expression in let UnionT(l) = general in (List.map (appartient (l)) (m)))

let rec inclu2 (ex : tp list) (gen : tp list) = let rec uni (e : tp list) = (match e with 
                                                                          |[a]-> a
                                                                          |[] -> UnionT([NoneT])
                                                                          |a::l -> union (a) (uni l)) in inclu (uni ex) (uni gen)

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
	                                        |Some (tplist, tpretour) -> if (inclu2 (List.map (tp_expr env) (l)) (tplist)) then tpretour else raise Argument_incorect)

exception Code_inatteignable
exception Variable_pas_instancie
exception Fonction_mal_def
exception Condition_doit_etre_un_bool


let rec replace (glob : environment) (env : (vname * tp) list) (var : vname) (typ : expr) = match env with
              |[] -> []
              |(name,typp)::l -> if name = var then [(var,(tp_expr glob typ))]@replace glob l var typ else [(name,typp)]@replace glob l var typ

let rec appar (v : vname) (tii : tp) (j : (vname * tp) list) = match j with 
          |[] -> []
          |(vn,ti)::l -> if vn = v then ([(vn,union ti tii)]@l) else ([(vn,ti)]@(appar v tii l))

let rec fu2 (l1 : (vname * tp) list) (l2 : (vname * tp) list) : ((vname * tp) list) = match l1 with 
                      |[] -> []
                      |(vna,tiipe)::g -> (appar vna tiipe l2)@(fu2 g l2)

let rec fu (env1 : environment) (env2 : environment) : environment = match env1,env2 with
                              |_,_ -> {fdecls= env1.fdecls;static_vars= env1.static_vars;dyn_vars= { globals = (fu2 (env1.dyn_vars.globals) (env2.dyn_vars.globals)) ; locals =  (fu2 (env1.dyn_vars.locals) (env2.dyn_vars.locals)) };curfun= env1.curfun;}



let rec tp_stmt ((env, t, returned) : (environment * tp * bool)) stm : (environment * tp * bool) = let rec etape ((env, retour, returnn) : (environment * tp * bool)) liste = match liste with 
          |[] -> (env, retour, returnn)
          |stm::l -> etape (tp_stmt (env, retour, returnn) stm) (l) in match (stm,returned) with 
              | (_,true) -> raise Code_inatteignable
              | (Block l,false) -> (etape (env, t, returned) (l))
              | (Assign (v,ex),false) -> let tipe = let looking = (look env.static_vars.locals v) in (match looking with
	                                        |None -> (let looking2 = (look env.static_vars.globals v) in (match looking2 with
	                                                |None -> raise Variable_inexistante 
	                                                |Some t -> t ))
	                                        |Some t -> t )  
                                       in if inclu (tp_expr env ex) (tipe) then let globa = (replace env env.dyn_vars.globals v ex) and loca = (replace env env.dyn_vars.locals v ex) in 
                                       let new_env = {fdecls= env.fdecls;static_vars= env.static_vars;dyn_vars= { globals = globa; locals = loca };curfun= env.curfun;} in
                                       (new_env,t,returned)
                                       else raise Variable_pas_instancie
              
			        |(Cond (e,s1,s2),false)  -> let rec fusion (env : environment) (si : stmt) (alors : stmt) : (environment * tp * bool) = 
              let (env1, t1, ret1) = tp_stmt (env, UnionT[NoneT],false) (si) and (env2, t2, ret2) = tp_stmt (env, UnionT[NoneT],false) (alors) 
              in (fu (env1) (env2), union t1 t2, ret1 && ret2) in if (inclu (tp_expr env e) (UnionT([BoolT]))) then fusion env s1 s2 else raise Condition_doit_etre_un_bool
              |(While(e,s),false) ->let rec egal = ?? in let rec kaneki ((env, t, returned) : environment*tp*bool) (stmm : stmt) (i : int): (environment*tp*bool) -> 	let (a,b,c) = (tp_stmt (env, t, returned) stmm) in if (egal a env) 
                                                                                                                                                                  then (if i > 1 
                                                                                                                                                                    then (a,b,c) 
                                                                                                                                                                    else (kaneki (a, b, c) s (i+1))) 
                                                                                                                                                                  else (kaneki (a, b, c) s (i)) 
                                    in if (inclu (tp_expr env e) (UnionT([BoolT]))) then (kaneki (env, t, returned) s 0) else raise Condition_doit_etre_un_bool
              |(Return (expre),false) -> (env, (tp_expr env expre), true)
              |(CallS (vn, explist),false) -> let looking = (look2 env.fdecls vn) in (match looking with
	                                        |None -> raise Fonction_non_def
	                                        |Some (tplist, tpretour) -> if (inclu2 (List.map (tp_expr env) (explist)) (tplist)) then (env, t, returned) else raise Argument_incorect)
              (*|_,_ -> Printf.printf"type inconnu \n";(env, t, returned) *)




let tp_fundefn (env_init : environment) (funn : (fundecl * (vardecl list) * stmt)) = let (f, vds, s ) =funn in let Fundecl(fn, pards, rt) = f in let (envr,retour,returne) = (tp_stmt (env_init,UnionT([NoneT]),false) (s) ) in (inclu retour rt);;

  (* Function declarations of library / predefined functions *)
let library_fds = [
    ("input", ([UnionT[StringT]], UnionT[StringT]))
  ; ("int",   ([UnionT[BoolT; FloatT; IntT; StringT]], UnionT[IntT]))
  ; ("print", ([UnionT[StringT]], UnionT[NoneT]))
  ; ("str",   ([UnionT[BoolT; FloatT; IntT; StringT]], UnionT[StringT]))
  ]


let rec varcl_to_list (p : vardecl list) : ((vname * tp) list) = match p with
                      |[]-> []
                      |Vardecl(a,b)::l -> [(a,b)]@(varcl_to_list l)

let rec typage (v : vardecl list) : (tp list) = match v with
                      |[]-> []
                      |Vardecl(v,t)::l -> [t]@(typage l)

let rec maj_env_fonc (list_fonc : fundefn list) : (string*(tp list*tp)) list= match list_fonc with 
                  |[] -> []
                  |Fundefn(prems, vds, s)::reste ->let Fundecl(fn, pards, rt) = prems in let init_env = 
                                {fdecls = [] @ library_fds; static_vars = { globals = []; locals = varcl_to_list (pards @ vds) }; dyn_vars = { globals = []; locals = varcl_to_list (pards @ vds)}; curfun = None} 
                              in
                                if duplicate_free (List.map fst init_env.static_vars.locals) && (tp_fundefn (init_env) ((Fundecl(fn, pards, rt), vds, s))) 
                                    then [(fn,(typage pards,rt))]@maj_env_fonc (reste)
                                    else raise Fonction_mal_def
                   

(* The following has to be defined in detail *)
let rec tp_prog (Prog(fdefns, vds, s)) = 
  let fds = (maj_env_fonc fdefns) in
  let globs = varcl_to_list (vds) in
  let init_venv = { globals = globs; locals = [] } in 
  let init_env = 
    { fdecls = fds @ library_fds; static_vars = init_venv; dyn_vars = init_venv; curfun = None } in
  if duplicate_free (List.map fst fds) 
    && duplicate_free (List.map fst globs)
  then tp_stmt (init_env, UnionT[NoneT], false) s
  else failwith "duplicate function or variable declarations";;
