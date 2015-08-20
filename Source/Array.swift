/**
    map a function over an array of values

    This will return a new array resulting from the transformation function being applied to each value in the array

    - parameter f: A transformation function from type `T` to type `U`
    - parameter a: A value of type `[T]`

    - returns: A value of type `[U]`
*/
public func <^> <T, U>(f: T -> U, a: [T]) -> [U] {
    return a.map(f)
}

/**
    apply an array of functions to an array of values

    This will return a new array resulting from the matrix of each function being applied to each value in the array

    - parameter fs: An array of transformation functions from type `T` to type `U`
    - parameter a: A value of type `[T]`

    - returns: A value of type `[U]`
*/
public func <*> <T, U>(fs: [T -> U], a: [T]) -> [U] {
    return a.apply(fs)
}

/**
    flatMap a function over an array of values (left associative)

    apply a function to each value of an array and flatten the resulting array

    - parameter f: A transformation function from type `T` to type `[U]`
    - parameter a: A value of type `[T]`

    - returns: A value of type `[U]`
*/
public func >>- <T, U>(a: [T], f: T -> [U]) -> [U] {
    return a.flatMap(f)
}

/**
    flatMap a function over an array of values (right associative)

    apply a function to each value of an array and flatten the resulting array

    - parameter f: A transformation function from type `T` to type `[U]`
    - parameter a: A value of type `[T]`

    - returns: A value of type `[U]`
*/
public func -<< <T, U>(f: T -> [U], a: [T]) -> [U] {
  return a.flatMap(f)
}

/**
    Wrap a value in a minimal context of `[]`

    - parameter a: A value of type `T`

    - returns: The provided value wrapped in an array
*/
public func pure<T>(a: T) -> [T] {
    return [a]
}

public extension Array {
    /**
        apply an array of functions to `self`

        This will return a new array resulting from the matrix of each function being applied to each value inside `self`

        - parameter fs: An array of transformation functions from type `Element` to type `U`

        - returns: A value of type `[U]`
    */
    func apply<U>(fs: [Element -> U]) -> [U] {
        return fs.flatMap { self.map($0) }
    }
}
