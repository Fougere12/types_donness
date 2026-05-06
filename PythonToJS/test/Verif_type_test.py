def affectation_block_retour() -> bool:
  #begin
  x : int
  y : int
  x = 3
  y = 5
  return x == y
  #end


def bool_int() -> None:
  #begin
  x : int
  x = True
  x = 1
  #end


def if_correct() -> int:
  #begin
  x : int
  if True:
    #begin
    x = 3
    #end
  else:
    #begin
    x = 4
    #end
  return x
  #end



def while_test() -> int:
  #begin
  x : int
  while True:
    #begin
    x = 3
    #end
  return x
  #end


def f(x : int) -> int:
  #begin
  return x
  #end

  
def appel() -> int:
  #begin
  y : int
  y = f(3)
  return y
  #end

def test_print() -> None:
  #begin
  print("hello")
  #end


def int_float() -> None:
  #begin
  x : float
  x = 3
  x = 3.5
  #end


def comparaison() -> bool:
  #begin
  x : int
  y : int
  z : bool
  x = 3
  y = 4
  z = x < y
  return z
  #end



def bool_logique() -> bool:
  #begin
  x : bool
  x = True and False
  return x
  #end


def arithmetique() -> int:
  #begin
  x : int
  y : int
  z : int
  x = 3
  y = 2
  z = x + y
  return z
  #end
