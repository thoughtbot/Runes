public func <^><T, U>(f: T -> U, a: [T]) -> [U] {
    return a.map(f)
}

public func <*><T, U>(fs: [T -> U], a: [T]) -> [U] {
    return fs >>- { f in a.map(f) }
}

public func >>-<T, U>(a: [T], f: T -> [U]) -> [U] {
    return a.reduce([]) { bs, a in bs + f(a) }
}
