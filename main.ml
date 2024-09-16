#use "topfind"
open OptVectorData
#use "CCVector.ml"
open Runcode

(*
type 'a opt_vector =
  | OptNil
  | OptPush of ('a opt_vector * 'a code)
  | OptPop of ('a opt_vector);;
*)

let get_opt v i =
  if i < 0 || i >= v.size then None else Some (get v i)

(** get the nth element starting from the back *)
let rec back_nth n v : ('a option) code =
  match v with
  | OptFrom vec -> .<(get_opt vec (length vec - n - 1))>.
  | OptPush (v, x) -> if n = 0 then .<(Some x)>. else back_nth (n - 1) v
  | OptPop v -> back_nth (n + 1) v

(** get the last element *)
let back =
  fun v -> back_nth 0 v

(** Create an empty vector *)
let create_opt () = OptFrom (create ())

(** Create a vector from an existing vector *)
let create_from_opt v = OptFrom v


(** Push one element in the vector *)
let push_opt v x = OptPush (v, x)

(** Pop one element from the vector and gets its value now *)
let pop_opt v = match v with
  | OptPush (v', x) -> v', .<Some x>.
  | _ -> OptPop v, back v

(* Two functions that do some computations *)

let foo () = 0
let bar () = 1

(* Make sure a pop/push sequence is optimized *)
let prog1 () =
    let v = create_opt () in
    let v1 = push_opt v .<foo ()>. in
    let v2 = push_opt v1 .<bar ()>. in 
    let v3, res = pop_opt v2 in
    res
(* .<Some csp_x_3>. *)    

(* Make sure a get is correctly staged *)
let prog2 () =
  let v = create_from_opt (of_list [0; 2; 4; 5]) in
  let v1, res = pop_opt v in
  res
(* csp_get_opt_4 csp_vec_3 (((csp_length_2 csp_vec_1) - 0) - 1)>. *)

let _ = prog1 ()

push p x;
if a then begin
  let y = pop p;
end else begin
  let y = pop p;
end
