def affectation() -> int:
  #begin
  a : int
  a = 2
  return a
  #end

def condition(n : int) -> bool:
  #begin
  a : int
  a = 3
  if a<n:
    #begin
    return True
    #end
  else:
    #begin
    return False
    #end
  #end


def boucle_while(n : int) -> int:
  #begin
  a : int
  a = 0
  while a<n:
    #begin  
    a = a + 1
    #end
  return a
  #end


def affichage(nom : str) -> None:
  #begin
  print("Bonjour")
  print(nom)
  #end


def complet(nom : str, n : int) -> bool:
  #begin
  a : int
  x : float
  a = 1
  x = 32
  print(nom)
  while a<n:
    #begin
    if (nom == "Yannis" or nom == "Anais"):
      #begin
      x = x*2
      print(x)
      #end
    else:
      #begin
      x = x/2
      #end
    if (x==16 and a==16):
        #begin
        return True
        #end
    else:
      #begin
      print("pas encore bon")
      #end
    a=a*2
    #end
  return x==a
  #end
      


def division_euclidienne(a : int, b : int) -> int:
  #begin
  q : int
  r : int
  q = 0
  r = a

  while r >= b:
    #begin
    r = r - b
    q = q + 1
    #end

  print(q)
  print(r)

  return q
  #end
