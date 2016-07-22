func id<A>(_ a: A) -> A {
    return a
}

func curry<A, B, C>(_ f: (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) }}
}
