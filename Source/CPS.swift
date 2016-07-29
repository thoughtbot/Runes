/**
    map a function over a CPS function

    This will return a new CPS function by applying the transformation function to the value in the continuation

    - parameter f: A transformation function from type `T` to type `U`
    - parameter a: A CPS function of type `(T -> Void) -> Void`

    - returns: A CPS function of type `(U -> Void) -> Void`
*/
public func <^> <T, U>(f: T -> U, a: (T -> Void) -> Void) -> (U -> Void) -> Void {
    return a >>- { pure(f($0)) }
}

/**
    apply a function in a CPS over a CPS function

    This will return a new CPS function by applying a function from a CPS's continuation to a value from another CPS

    - parameter f: CPS function which pass A transformation function from type `T` to type `U`
    - parameter a: A CPS function of type `(T -> Void) -> Void`

    - returns: A CPS function of type `(U -> Void) -> Void`
*/
public func <*> <T, U>(f: ((T -> U) -> Void) -> Void, a: (T -> Void) -> Void) -> (U -> Void) -> Void {
    return f >>- { $0 <^> a }
}

/**
    flatMap a function over a CPS function (left associative)

    apply a function to the value of the continuation in a CPS function and flatten the resulting CPS function

    - parameter f: A transformation function from type `T` to type `(U -> Void) -> Void`
    - parameter a: A CPS function of type `(T -> Void) -> Void`

    - returns: A value of type `(U -> Void) -> Void`
*/
public func >>- <T, U>(a: (T -> Void) -> Void, f: T -> (U -> Void) -> Void) -> (U -> Void) -> Void {
    return {x in a{f($0)({x($0)})}}
}

/**
    flatMap a function over a CPS function (right associative)

    apply a function to the value of the continuation in a CPS function and flatten the resulting CPS function

    - parameter f: A transformation function from type `T` to type `(U -> Void) -> Void`
    - parameter a: A CPS function of type `(T -> Void) -> Void`

    - returns: A value of type `(U -> Void) -> Void`
*/
public func -<< <T, U>(f: T -> (U -> Void) -> Void, a: (T -> Void) -> Void) -> (U -> Void) -> Void {
    return a >>- f
}

/**
 compose two functions that produce CPS functions, from left to right

 produces a function that applies that flatMaps the second function over the result of the first function

 - parameter f: A transformation function from type `A` to type `(B->Void)->Void`
 - parameter g: A transformation function from type `B` to type `(C->Void)->Void`

 - returns: A value of type `(C->Void)->Void`
 */
public func >-> <A, B, C>(f: A -> (B->Void)->Void, g: B -> (C->Void)->Void) -> A -> (C->Void)->Void {
    return { x in f(x) >>- g }
}

/**
 compose two functions that produce CPS functions, from right to left

 produces a function that applies that flatMaps the first function over the result of the second function

 - parameter f: A transformation function from type `B` to type `(C->Void)->Void`
 - parameter g: A transformation function from type `A` to type `(B->Void)->Void`

 - returns: A value of type `(C->Void)->Void`
 */
public func <-< <A, B, C>(f: B -> (C->Void)->Void, g: A -> (B->Void)->Void) -> A -> (C->Void)->Void {
    return { x in g(x) >>- f }
}

/**
    Wrap a value in a minimal context of `{$0(x)}`

    - parameter a: A value of type `T`

    - returns: The provided value wrapped in a CPS function
*/
public func pure<T> (a: T) -> (T->Void) -> Void {
    return { $0(a) }
}
