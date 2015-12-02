/**
    map a function over an optional value

    - If the value is `.None`, the function will not be evaluated and this will return `.None`
    - If the value is `.Some`, the function will be applied to the unwrapped value

    - parameter f: A transformation function from type `T` to type `U`
    - parameter a: A value of type `Optional<T>`

    - returns: A value of type `Optional<U>`
*/
public func <^> <T, U>(@noescape f: T -> U, a: T?) -> U? {
    return a.map(f)
}

/**
    apply an optional function to an optional value

    - If either the value or the function are `.None`, the function will not be evaluated and this will return `.None`
    - If both the value and the function are `.Some`, the function will be applied to the unwrapped value

    - parameter f: An optional transformation function from type `T` to type `U`
    - parameter a: A value of type `Optional<T>`

    - returns: A value of type `Optional<U>`
*/
public func <*> <T, U>(f: (T -> U)?, a: T?) -> U? {
    return a.apply(f)
}

/**
    flatMap a function over an optional value (left associative)

    - If the value is `.None`, the function will not be evaluated and this will return `.None`
    - If the value is `.Some`, the function will be applied to the unwrapped value

    - parameter f: A transformation function from type `T` to type `Optional<U>`
    - parameter a: A value of type `Optional<T>`

    - returns: A value of type `Optional<U>`
*/
public func >>- <T, U>(a: T?, @noescape f: T -> U?) -> U? {
    return a.flatMap(f)
}

/**
    flatMap a function over an optional value (right associative)

    - If the value is `.None`, the function will not be evaluated and this will return `.None`
    - If the value is `.Some`, the function will be applied to the unwrapped value

    - parameter a: A value of type `Optional<T>`
    - parameter f: A transformation function from type `T` to type `Optional<U>`

    - returns: A value of type `Optional<U>`
*/
public func -<< <T, U>(@noescape f: T -> U?, a: T?) -> U? {
  return a.flatMap(f)
}

/**
    compose two functions that produce optional values, from left to right

    - If the result of the first function is `.None`, the second function will not be inoked and this will return `.None`
    - If the result of the first function is `.Some`, the value is unwrapped and passed to the second function which may return `.None`

    - parameter f: A transformation function from type `A` to type `Optional<B>`
    - parameter g: A transformation function from type `B` to type `Optional<C>`

    - returns: A function from type `A` to type `Optional<C>`
*/
public func >-> <A, B, C>(f: A -> B?, g: B -> C?) -> A -> C? {
    return { x in f(x) >>- g }
}

/**
    compose two functions that produce optional values, from right to left

    - If the result of the first function is `.None`, the second function will not be inoked and this will return `.None`
    - If the result of the first function is `.Some`, the value is unwrapped and passed to the second function which may return `.None`

    - parameter f: A transformation function from type `B` to type `Optional<C>`
    - parameter g: A transformation function from type `A` to type `Optional<B>`

    - returns: A function from type `A` to type `Optional<C>`
 */
public func <-< <A, B, C>(f: B -> C?, g: A -> B?) -> A -> C? {
    return { x in g(x) >>- f }
}

/**
    Wrap a value in a minimal context of `.Some`

    - parameter a: A value of type `T`

    - returns: The provided value wrapped in `.Some`
*/
public func pure<T>(a: T) -> T? {
    return .Some(a)
}

public extension Optional {
    /**
        apply an optional function to `self`

        - If either self or the function are `.None`, the function will not be evaluated and this will return `.None`
        - If both self and the function are `.Some`, the function will be applied to the unwrapped value

        - parameter f: An optional transformation function from type `Wrapped` to type `U`

        - returns: A value of type `Optional<U>`
    */
    func apply<U>(f: (Wrapped -> U)?) -> U? {
        return f.flatMap { self.map($0) }
    }
}
