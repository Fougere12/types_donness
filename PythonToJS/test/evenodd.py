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


