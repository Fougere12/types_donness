open PPrint
open Lang


(* Global constant *)
let indent_level = 4

let doc_of_var v = string v

let doc_of_value v =
  match v with
  | BoolV b -> string (string_of_bool b)
  | IntV i -> string (string_of_int i)
  | FloatV f -> string (string_of_float f)
  | NoneV -> string "null"
  | StringV s -> string ("\"" ^ s ^ "\"")

let doc_of_binop op =
  match op with
  | BArith BAadd -> string "+"
  | BArith BAsub -> string "-"
  | BArith BAmul -> string "*"
  | BArith BAdiv -> string "/"
  | BArith BAmod -> string "%"
  | BBool BBand -> string "&&"
  | BBool BBor -> string "||"
  | BCompar BCeq -> string "=="
  | BCompar BCge -> string ">="
  | BCompar BCgt -> string ">"
  | BCompar BCle -> string "<="
  | BCompar BClt -> string "<"
  | BCompar BCne -> string "!="

let rec doc_of_expr e =
  match e with
  | Const x -> doc_of_value x
  | VarE v -> doc_of_var v
  | BinOp (op, e1, e2) -> parens (doc_of_expr e1 ^^ space ^^ doc_of_binop op ^^ space ^^ doc_of_expr e2)
  | CallE (f, args) -> string f ^^ parens (separate_map comma doc_of_expr args)

let doc_of_var_list vs = parens (separate_map comma string vs)


let rec doc_of_stmt s = match s with 
  | Block sl -> separate hardline (List.map doc_of_stmt sl)
  | Assign(v, e) -> doc_of_var v ^^ space ^^ string "=" ^^ space ^^ doc_of_expr e ^^ string ";"
  | Cond(e,s1,s2) ->
    nest indent_level (string "if (" ^^ doc_of_expr e ^^ string ") {" ^^ hardline ^^
    doc_of_stmt s1) ^^ hardline ^^
    nest indent_level (string "} else {" ^^ hardline ^^
    doc_of_stmt s2) ^^ hardline ^^
    string "}"
  | While(e,s) ->
    nest indent_level (string "while (" ^^ doc_of_expr e ^^ string ") {" ^^ hardline ^^
    doc_of_stmt s) ^^ hardline ^^
    string "}"
  | Return(e) -> string "return " ^^ doc_of_expr e ^^ string ";"
  | CallS ("print", args) -> string "alert" ^^ parens (separate_map comma doc_of_expr args) ^^ string ";"
  | CallS (f, args) -> string f ^^ parens (separate_map comma doc_of_expr args) ^^ string ";"
 

let doc_of_local_vardecl (Vardecl(vn,_t)) = string "let" ^^ space ^^ string vn ^^ string ";"
let doc_of_global_vardecl (Vardecl(vn,_t)) = string "let" ^^ space ^^ string vn ^^ string ";"


let doc_of_fundefn (Fundefn(Fundecl(fn, params, _rt), vds, s)) =
  nest indent_level (string "function" ^^ space ^^ string fn ^^
  doc_of_var_list (List.map name_of_vardecl params) ^^ space ^^
  string "{" ^^ hardline ^^
  
    separate hardline (List.map doc_of_local_vardecl vds) ^^ hardline ^^
    doc_of_stmt s
  ) ^^ hardline ^^
  string "}"

let doc_of_prog (Prog(fdfs, vds, s)) = 
  (separate_map hardline doc_of_fundefn fdfs) ^^
  hardline ^^
  (separate hardline
          [
            (separate hardline (List.map doc_of_global_vardecl vds)) 
          ; (doc_of_stmt s)
          ]  ) ^^  
  hardline


let print_prog prg =
  ToChannel.pretty 0.5 80 stdout (doc_of_prog prg);
  flush stdout

