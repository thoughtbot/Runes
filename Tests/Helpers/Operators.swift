infix operator • {
    associativity right
    precedence 170
}

func • <A, B, C> (f: B -> C, g: A -> B) -> A -> C {
    return { x in f(g(x)) }
}
