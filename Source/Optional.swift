/**
    map a function over an optional value

    - If the value is .None, the function will not be evaluated and this will return .None
    - If the value is .Some, the function will be applied to the unwrapped value

    :param: f A transformation function from type T to type U
    :param: a A value of type Optional<T>

    :returns: A value of type Optional<U>
*/
public func <^><T, U>(f: T -> U, a: T?) -> U? {
    return a.map(f)
}

/**
    apply an optional function to an optional value

    - If either the value or the function are .None, the function will not be evaluated and this will return .None
    - If both the value and the function are .Some, the function will be applied to the unwrapped value

    :param: f An optional transformation function from type T to type U
    :param: a A value of type Optional<T>

    :returns: A value of type Optional<U>
*/
public func <*><T, U>(f: (T -> U)?, a: T?) -> U? {
    return a.apply(f)
}

/**
    flatMap a function over an optional value

    - If the value is .None, the function will not be evaluated and this will return .None
    - If the value is .Some, the function will be applied to the unwrapped value

    :param: f A transformation function from type T to type Optional<U>
    :param: a A value of type Optional<T>

    :returns: A value of type Optional<U>
*/
public func >>-<T, U>(a: T?, f: T -> U?) -> U? {
    return a.flatMap(f)
}

/**
    Wrap a value in a minimal context of .Some

    :param: a A value of type T

    :returns: The provided value wrapped in .Some
*/
public func pure<T>(a: T) -> T? {
    return .Some(a)
}

extension Optional {
    /**
        apply an optional function to self

        - If either self or the function are .None, the function will not be evaluated and this will return .None
        - If both self and the function are .Some, the function will be applied to the unwrapped value

        :param: f An optional transformation function from type T to type U

        :returns: A value of type Optional<U>
    */
    func apply<U>(f: (T -> U)?) -> U? {
        switch (self, f) {
        case let (.Some(x), .Some(fx)): return fx(x)
        default: return .None
        }
    }

    /**
        flatMap a function over self

        - If self is .None, the function will not be evaluated and this will return .None
        - If self is .Some, the function will be applied to the unwrapped value

        :param: f A transformation function from type T to type Optional<U>

        :returns: A value of type Optional<U>
    */
    func flatMap<U>(f: T -> U?) -> U? {
        switch self {
        case let .Some(x): return f(x)
        default: return .None
        }
    }
}
