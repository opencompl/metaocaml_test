type complex = {re: float; im: float}

type _ cIR =
  | From : 'a code -> 'a cIR
  | CMul : (complex cIR * complex cIR) -> complex cIR
  | FMul : (float cIR * float cIR) -> float cIR
  | CNorm : (complex cIR) -> float cIR;;
  
