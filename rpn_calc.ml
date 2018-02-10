#load "str.cma"

(* List of allowed operators with the associated action *)
(* Grouped by their number of required parameters, 1 or 2, their arity. *)
let operators1 = [("v", sqrt);
                  ("l", log)]

let operators2 = [("+", (+.));
                  ("-", (-.));
                  ("*", ( *.));
                  ("/", (/.));
                  ("%", mod_float)]

(* Create an association list for operator <-> arity *)
let arity =
  let ar1 = List.map (fun (o, _) -> (o, 1)) operators1
  and ar2 = List.map (fun (o, _) -> (o, 2)) operators2 in
  ar1 @ ar2


(* Commands *)
let print_stack stk = stk |> List.rev_map string_of_float
                          |> String.concat " "
                          |> print_endline

let quit = (fun _ -> exit 0)  (* a thunk... *)

let commands = [("p", print_stack);
                ("q", quit)]


(* Predicates *)
let is_operator x = List.exists (fun (o, _) -> o = x) operators1
                 || List.exists (fun (o, _) -> o = x) operators2

let is_command x = List.exists (fun (c, _) -> c = x) commands

let is_float x = try let _ = float_of_string x in true with
                 | _ -> false


(* Execution of a command on the stack *)
let exec c = (List.assoc c commands)


(* Perform a computation with an operator *)
let compute op stk =
  let ar = List.assoc op arity in
  match (ar, stk) with
  | (_, []) -> failwith "Stack empty"
  | (ar, _ :: []) when ar > 1 -> failwith "Stack underflow"
  | (ar1, x :: xs) when ar1 = 1 ->
      (List.assoc op operators1) x :: xs
  | (ar2, y1 :: y2 :: ys) when ar2 = 2 ->
      (List.assoc op operators2) y2 y1 :: ys
  | (_, _) -> failwith "This should never happen... Weird arity?"


(* Process the expression already transformed as a list  *)
let process expl =
  let rec proc_rec stk lst =
    match (stk, lst) with
    | ([], []) -> failwith "Stack empty"
    | ([x], []) -> x
    | (_, []) -> failwith "Malformed expression"
    | (_, y :: ys) when is_float y -> proc_rec (float_of_string y :: stk) ys
    | (_, z :: zs) when is_operator z -> proc_rec (compute z stk) zs
    | (_, c :: cs) when is_command c -> let _ = exec c stk in proc_rec stk cs
    | (_, a :: _) -> failwith ("Element is invalid '" ^ a ^ "'") in
  proc_rec [] expl


(* Split the string and evaluate the expression *)
let eval s = s |> Str.split (Str.regexp "[ \t]+")
               |> List.map (fun s1 -> if not (is_float s1)
                                      then Str.split (Str.regexp "") s1
                                      else [s1])
               |> List.flatten
               |> process


(* Main loop *)
let () =
  (* Infinite loop *)
  let rec loopit () =
    let _ = read_line () |> eval |> string_of_float |> print_endline in
    loopit () in
  try loopit () with
  | End_of_file -> let _ = quit in ()


