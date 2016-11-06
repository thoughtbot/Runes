/**
  map a function over an optional value

  - If the value is `.none`, the function will not be evaluated and this will
    return `.none`
  - If the value is `.some`, the function will be applied to the unwrapped
    value

  - parameter f: A transformation function from type `T` to type `U`
  - parameter a: A value of type `Optional<T>`

  - returns: A value of type `Optional<U>`
*/
public func <^> <T, U>(f: (T) -> U, a: T?) -> U? {
  return a.map(f)
}

/**
  apply an optional function to an optional value

  - If either the value or the function are `.none`, the function will not be
    evaluated and this will return `.none`
  - If both the value and the function are `.some`, the function will be
    applied to the unwrapped value

  - parameter f: An optional transformation function from type `T` to type `U`
  - parameter a: A value of type `Optional<T>`

  - returns: A value of type `Optional<U>`
*/
public func <*> <T, U>(f: ((T) -> U)?, a: T?) -> U? {
  return a.apply(f)
}

/**
  flatMap a function over an optional value (left associative)

  - If the value is `.none`, the function will not be evaluated and this will
    return `.none`
  - If the value is `.some`, the function will be applied to the unwrapped
    value

  - parameter f: A transformation function from type `T` to type `Optional<U>`
  - parameter a: A value of type `Optional<T>`

  - returns: A value of type `Optional<U>`
*/
public func >>- <T, U>(a: T?, f: (T) -> U?) -> U? {
  return a.flatMap(f)
}

/**
  flatMap a function over an optional value (right associative)

  - If the value is `.none`, the function will not be evaluated and this will
    return `.none`
  - If the value is `.some`, the function will be applied to the unwrapped
    value

  - parameter a: A value of type `Optional<T>`
  - parameter f: A transformation function from type `T` to type `Optional<U>`

  - returns: A value of type `Optional<U>`
*/
public func -<< <T, U>(f: (T) -> U?, a: T?) -> U? {
  return a.flatMap(f)
}

/**
  compose two functions that produce optional values, from left to right

  - If the result of the first function is `.none`, the second function will
    not be inoked and this will return `.none`
  - If the result of the first function is `.some`, the value is unwrapped and
    passed to the second function which may return `.none`

  - parameter f: A transformation function from type `T` to type `Optional<U>`
  - parameter g: A transformation function from type `U` to type `Optional<V>`

  - returns: A function from type `T` to type `Optional<V>`
*/
public func >-> <T, U, V>(f: @escaping (T) -> U?, g: @escaping (U) -> V?) -> (T) -> V? {
  return { x in f(x) >>- g }
}

/**
  compose two functions that produce optional values, from right to left

  - If the result of the first function is `.none`, the second function will
    not be inoked and this will return `.none`
  - If the result of the first function is `.some`, the value is unwrapped and
    passed to the second function which may return `.none`

  - parameter f: A transformation function from type `U` to type `Optional<V>`
  - parameter g: A transformation function from type `T` to type `Optional<U>`

  - returns: A function from type `T` to type `Optional<V>`
*/
public func <-< <T, U, V>(f: @escaping (U) -> V?, g: @escaping (T) -> U?) -> (T) -> V? {
  return { x in g(x) >>- f }
}

/**
  Wrap a value in a minimal context of `.some`

  - parameter a: A value of type `T`

  - returns: The provided value wrapped in `.some`
*/
public func pure<T>(_ a: T) -> T? {
  return .some(a)
}

public extension Optional {
  /**
    apply an optional function to `self`

    - If either self or the function are `.none`, the function will not be
      evaluated and this will return `.none`
    - If both self and the function are `.some`, the function will be applied
      to the unwrapped value

    - parameter f: An optional transformation function from type `Wrapped` to type `T`

    - returns: A value of type `Optional<T>`
  */
  func apply<T>(_ f: ((Wrapped) -> T)?) -> T? {
    return f.flatMap { self.map($0) }
  }
}
