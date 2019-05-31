/**
  apply a function from a result to an result value

  - If either the value or the function are `.failure`, the function will not
    be evaluated and this will return the original error wrapped in `.failure`
  - If both the value and the function are `.success`, the function will be
    applied to the unwrapped value

  - parameter f: A result containing a transformation function from type `T` to
    type `U`
  - parameter a: A value of type `Result<T, E>`

  - returns: A value of type `Result<U, E>`
*/
public func <*> <T, U, E>(f: Result<(T) -> U, E>, a: Result<T, E>) -> Result<U, E> {
  return a.apply(f)
}

/**
  Sequence two values, discarding the right hand value

  - If the right hand value is `.failure`, this will return the original error
    wrapped in `.failure`
  - If the right hand value is `.success`, this will return the left hand value

  - parameter lhs: A value of type `Result<T, E>`
  - parameter rhs: A value of type `Result<U, E>`

  - returns: a value of type `Result<T, E>`
*/
public func <* <T, U, E>(lhs: Result<T, E>, rhs: Result<U, E>) -> Result<T, E> {
  switch (lhs, rhs) {
  case let (.failure(err), _): return .failure(err)
  case let (_, .failure(err)): return .failure(err)
  case (.success, .success): return lhs
  }
}

/**
  Sequence two values, discarding the left hand value

  - If the left hand value is `.failure`, this will return the original error
    wrapped in `.failure`
  - If the left hand value is `.success`, this will return the right hand value

  - parameter lhs: A value of type `Result<T, E>`
  - parameter rhs: A value of type `Result<U, E>`

  - returns: a value of type `Result<U, E>`
*/
public func *> <T, U, E>(lhs: Result<T, E>, rhs: Result<U, E>) -> Result<U, E> {
  switch (lhs, rhs) {
  case let (.failure(err), _): return .failure(err)
  case let (_, .failure(err)): return .failure(err)
  case (.success, .success): return rhs
  }
}

/**
  Wrap a value in a minimal context of `.success`

  - parameter a: A value of type `T`

  - returns: The provided value wrapped in `.success`
*/
public func pure<T, E>(_ a: T) -> Result<T, E> {
  return .success(a)
}

public extension Result {
  /**
    apply a Result containing a function to `self`

    - If either self or the function are `.failure`, the function will not be
      evaluated and this will return the original error wrapped in `.failure`
    - If both self and the function are `.success`, the function will be applied
      to the unwrapped value

    - parameter f: An optional transformation function from type `Success` to type `T`

    - returns: A value of type `Result<T, Failure>`
  */
  func apply<T>(_ f: Result<(Success) -> T, Failure>) -> Result<T, Failure> {
    return f.flatMap { self.map($0) }
  }
}
