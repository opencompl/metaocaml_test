#use "topfind"
open OptComplex;;
open Runcode;;

(***************************************************************
                    Complex example
***************************************************************)
let cmul x y =
  {re = x.re *. y.re -. x.im *. y.im; im = x.re *. y.im +. y.re *. x.im};;
  
let norm x = x.re *. x.re +. x.im *. x.im;;


let rec optimize : type a. a cIR -> a cIR = function
| From x -> From x
| CMul (x, y) -> CMul (optimize x, optimize y)
| FMul (x, y) -> FMul (optimize x, optimize y)
| CNorm (CMul (x, y)) ->
    FMul (optimize (CNorm x), optimize (CNorm y))
| CNorm x -> CNorm (optimize x);;

let rec execute : type a. a cIR -> a code = function
  | From x -> x
  | CMul (x, y) -> .< (cmul (.~(execute x)) .~(execute y)) >.
  | FMul (x, y) -> .< (.~(execute x) *. .~(execute y)) >.
  | CNorm x -> .< norm .~(execute x) >.;;


let conorm x y = norm (cmul x y)

let conorm_opt =
  run .< (fun x y -> .~(execute (optimize (CNorm (CMul (From .<x>., From .<y>.)))))) >.;;

let problematic x y =
  let a = cmul x y in
  let b = norm a in
  foo a b
(* We don't want to optimize `b`, as we want to keep the intermediate result `a`*)

let problematic2 c x1 y1 x2 y2 =
  let a = cmul x1 y1 in
  let b = cmul x2 y2 in
  if c then norm a else norm b
(* We don't know which branch is being executed, so staging this code is hard *)


