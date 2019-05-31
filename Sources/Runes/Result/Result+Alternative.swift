/**
  Return a successful value or the provided default

  - If the left hand value is `.success`, this will return the left hand value
  - If the left hand value is `.failure`, this will return the default on the
    right hand side

  - parameter lhs: A value of type `Result<T, E>`
  - parameter rhs: A value of type `Result<T, E>`

  - returns: a value of type `Result<T, E>`
*/
public func <|> <T, E>(lhs: Result<T, E>, rhs: @autoclosure () -> Result<T, E>) -> Result<T, E> {
  return lhs.or(rhs())
}

public extension Result {
  /**
    Return a successful value or the provided default

    - If `self` is `.success`, this will return `self`
    - If `self` is `.failure`, this will return the provided default

    - parameter other: A value of type `Result<Success, Failure>`

    - returns: a value of type `Result<Success, Failure>`
  */
  func or(_ other: @autoclosure () -> Result<Success, Failure>) -> Result<Success, Failure> {
    switch self {
      case .success: return self
      case .failure: return other()
    }
  }
}
