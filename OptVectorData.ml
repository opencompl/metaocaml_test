type ('a, 'b) opt_vector =
  | OptFrom of 'b
  | OptPush of (('a, 'b) opt_vector * 'a)
  | OptPop of (('a, 'b) opt_vector);;
