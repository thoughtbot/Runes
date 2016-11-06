func const<T, U>(x: T, y: U) -> T {
  return x
}

func id<A>(_ a: A) -> A {
  return a
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in { b in f(a, b) }}
}
