/**
  flatMap a function over a result (left associative)

  - If the value is `.failure`, the function will not be evaluated and this
    will return the original error wrapped in `.failure`
  - If the value is `.success`, the function will be applied to the unwrapped
    value

  - parameter f: A transformation function from type `T` to type `Result<U, E>`
  - parameter a: A value of type `Result<T, E>`

  - returns: A value of type `Result<U, E>`
*/
public func >>- <T, U, E>(a: Result<T, E>, f: (T) -> Result<U, E>) -> Result<U, E> {
  return a.flatMap(f)
}

/**
  flatMap a function over a result (right associative)

  - If the value is `.failure`, the function will not be evaluated and this
    will return the original error wrapped in `.failure`
  - If the value is `.success`, the function will be applied to the unwrapped
    value

  - parameter a: A value of type `Result<T, E>`
  - parameter f: A transformation function from type `T` to type `Result<U, E>`

  - returns: A value of type `Result<U, E>`
*/
public func -<< <T, U, E>(f: (T) -> Result<U, E>, a: Result<T, E>) -> Result<U, E> {
  return a.flatMap(f)
}

/**
  compose two functions that produce results, from left to right

  - If the result of the first function is `.failure`, the second function will
    not be inoked and this will return the original error wrapped in `.failure`
  - If the result of the first function is `.success`, the value is unwrapped and
    passed to the second function which may return `.failure`

  - parameter f: A transformation function from type `T` to type `Result<U, E>`
  - parameter g: A transformation function from type `U` to type `Result<V, E>`

  - returns: A function from type `T` to type `Result<V, E>`
*/
public func >-> <T, U, V, E>(f: @escaping (T) -> Result<U, E>, g: @escaping (U) -> Result<V, E>) -> (T) -> Result<V, E> {
  return { x in f(x) >>- g }
}

/**
  compose two functions that produce results, from right to left

  - If the result of the first function is `.failure`, the second function will
    not be inoked and this will return the original error wrapped in `.failure`
  - If the result of the first function is `.success`, the value is unwrapped and
    passed to the second function which may return `.failure`

  - parameter f: A transformation function from type `U` to type `Result<V, E>`
  - parameter g: A transformation function from type `T` to type `Result<U, E>`

  - returns: A function from type `T` to type `Result<V, E>`
*/
public func <-< <T, U, V, E>(f: @escaping (U) -> Result<V, E>, g: @escaping (T) -> Result<U, E>) -> (T) -> Result<V, E> {
  return { x in g(x) >>- f }
}
