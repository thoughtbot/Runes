/**
  apply an array of functions to an array of values

  This will return a new array resulting from the matrix of each function being
  applied to each value in the array

  - parameter fs: An array of transformation functions from type `T` to type `U`
  - parameter a: A value of type `[T]`

  - returns: A value of type `[U]`
*/
public func <*> <T, U>(fs: [(T) -> U], a: [T]) -> [U] {
  return a.apply(fs)
}

/**
  Wrap a value in a minimal context of `[]`

  - parameter a: A value of type `T`

  - returns: The provided value wrapped in an array
*/
public func pure<T>(_ a: T) -> [T] {
  return [a]
}

public extension Array {
  /**
    apply an array of functions to `self`

    This will return a new array resulting from the matrix of each function
    being applied to each value inside `self`

    - parameter fs: An array of transformation functions from type `Element` to
                    type `T`

    - returns: A value of type `[T]`
  */
  func apply<T>(_ fs: [(Element) -> T]) -> [T] {
    return fs.flatMap { self.map($0) }
  }
}
