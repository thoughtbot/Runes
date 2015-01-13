/**
    map a function over an array of values

    This will return a new array resulting from the transformation function beind applied to each value in the array

    :param: f A transformation function from type T to type U
    :param: a An array of type [T]

    :returns: An array of type [U]
*/
public func <^><T, U>(f: T -> U, a: [T]) -> [U] {
    return a.map(f)
}

/**
    apply an array of functions to an array of values

    This will return a new array resulting from the matrix of each function being applied to each value in the array

    :param: fs An array of transformation functions from type T to type U
    :param: a An array of type [T]

    :returns: An array of type [U]
*/
public func <*><T, U>(fs: [T -> U], a: [T]) -> [U] {
    return a.apply(fs)
}

/**
    flatMap a function over an array of values

    apply a function to each value of an array and flatten the resulting array

    :param: f A transformation function from type T to an array of type [U]
    :param: a An array of type [T]

    :returns: An array of type [U]
*/
public func >>-<T, U>(a: [T], f: T -> [U]) -> [U] {
    return a.flatMap(f)
}

/**
    Wrap a value in a minimal context of []

    :param: a A value of type T

    :returns: The provided value wrapped in an array
*/
public func pure<T>(a: T) -> [T] {
    return [a]
}

extension Array {
    /**
        apply an array of functions to self

        This will return a new array resulting from the matrix of each function being applied to each value inside self

        :param: fs An array of transformation functions from type T to type U

        :returns: An array of type [U]
    */
    func apply<U>(fs: [T -> U]) -> [U] {
        return fs.flatMap { f in self.map(f) }
    }

    /**
        flatMap a function over self

        map a function over each value inside self and flatten the result

        :param: f A transformation function from type T to an array of type [U]

        :returns: An array of type [U]
    */
    func flatMap<U>(f: T -> [U]) -> [U] {
        return reduce([]) { bs, a in bs + f(a) }
    }
}
