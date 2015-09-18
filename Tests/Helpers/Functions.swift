func id<A>(a: A) -> A {
    return a
}

func compose<A, B, C>(f: B -> C, _ g: A -> B) -> A -> C {
    return { x in f(g(x)) }
}

func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
    return { a in { b in f(a, b) }}
}
