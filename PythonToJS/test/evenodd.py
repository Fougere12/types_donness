def is_even(n: int) -> bool:
    #begin
    zero : int
    zero = 0
    return(n == zero or is_odd(n - 1))
    #end

def is_odd(n: int) -> bool:
    #begin
    return((n != 0) and is_even(n - 1))
    #end

def is_even(n: int) -> int:
    #begin
    y : int
    y=3
    n=2
    n = n+1
    if n==3:
        #begin
        return n-1
        #end
    else :
        #begin
        return n+4
        #end
    #end

x : int
x = 3
if x==3:
    #begin
    x=4
    x = 5
    #end
else :
    #begin
    x=1
    x= x+3
    x = 0
    #end
print(True or False)

while (x<4):
    #begin
    x = x+1
    #end
