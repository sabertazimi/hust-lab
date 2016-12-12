datatype ('a, 'b) Tree = Node of 'a * ('a, 'b) Tree * ('a, 'b) Tree
                        | Leaf of 'b

fun factorial n =
    let
        fun aux(n, acc) =
            if
                n = 0
            then
                acc
            else
                aux (n-1, n*acc)
    in
        aux (n,1)
    end
