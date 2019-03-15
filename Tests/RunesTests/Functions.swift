func const<T, U>(x: T, y: U) -> T {
  return x
}

func id<A>(_ a: A) -> A {
  return a
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in { b in f(a, b) }}
}

func compose<T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
  return { x in f(g(x)) }
}

precedencegroup CompositionPrecedence {
  associativity: right
  higherThan: BitwiseShiftPrecedence
}

infix operator • : CompositionPrecedence
func • <T, U, V>(f: @escaping (U) -> V, g: @escaping (T) -> U) -> (T) -> V {
  return compose(f, g)
}
