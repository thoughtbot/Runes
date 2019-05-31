/**
  map a function over an result value

  - If the value is `.failure`, the function will not be evaluated, and this will
    return the original error wrapped in `.failure`
  - If the value is `.success`, the function will be applied to the unwrapped
    value, and returned wrapped in `.success`

  - parameter f: A transformation function from type `T` to type `U`
  - parameter a: A value of type `Result<T, E>`

  - returns: A value of type `Result<U, E>`
*/
public func <^> <T, U, E>(f: (T) -> U, a: Result<T, E>) -> Result<U, E> {
  return a.map(f)
}
