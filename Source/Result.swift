import LlamaKit

/**
    map a function over a result

    - If the value is .Failure, the function will not be evaluated and this will return the failure
    - If the value is .Success, the function will be applied to the unwrapped value

    :param: f A transformation function from type T to type U
    :param: a A value of type Result<T, E>

    :returns: A value of type Result<U, E>
*/
public func <^><T, U, E>(f: T -> U, a: Result<T, E>) -> Result<U, E> {
    return a.map(f)
}

/**
    apply a function from a result to a result

    - If  the function is .Failure, the function will not be evaluated and this will return the error from the function result
    - If the value is .Failure, the function will not be evaluated and this will return the error from the passed result value
    - If both the value and the function are .Success, the unwrapped function will be applied to the unwrapped value

    :param: f A result containing a transformation function from type T to type U
    :param: a A value of type Result<T, E>

    :returns: A value of type Result<U, E>
*/
public func <*><T, U, E>(f: Result<(T -> U), E>, a: Result<T, E>) -> Result<U, E> {
    return a.apply(f)
}

/**
    flatMap a function over a result

    - If the value is .Failure, the function will not be evaluated and this will return the failure
    - If the value is .Success, the function will be applied to the unwrapped value

    :param: f A transformation function from type T to type Result<U, E>
    :param: a A value of type Result<T, E>

    :returns: A value of type Result<U, E>
*/
public func >>-<T, U, E>(a: Result<T, E>, f: T -> Result<U, E>) -> Result<U, E> {
    return a.flatMap(f)
}

@availability(*, unavailable, message="function (T -> U) does not return Result<U, E>, perhaps you meant f <^> val")
public func >>-<T, U, E>(a: Result<T, E>, f: T -> U) -> Result<U, E> {
    return a.map(f)
}

/**
    Wrap a value in a minimal context of .Success

    :param: a A value of type T

    :returns: The provided value wrapped in .Success
*/
public func pure<T, E>(a: T) -> Result<T, E> {
    return success(a)
}

extension Result {
    /**
        apply a function from a result to self

        - If  the function is .Failure, the function will not be evaluated and this will return the error from the function result
        - If self is .Failure, the function will not be evaluated and this will return the error from self
        - If both self and the function are .Success, the unwrapped function will be applied to self

        :param: f A result containing a transformation function from type T to type U

        :returns: A value of type Result<U, E>
    */
    func apply<U>(f: Result<(T -> U), E>) -> Result<U, E> {
        switch f {
        case let .Success(fx): return map(fx.unbox)
        case let .Failure(e): return failure(e.unbox)
        }
    }
}
