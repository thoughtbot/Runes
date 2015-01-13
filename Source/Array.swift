public func <^><T, U>(f: T -> U, a: [T]) -> [U] {
    return a.map(f)
}

public func <*><T, U>(fs: [T -> U], a: [T]) -> [U] {
    return a.apply(fs)
}

public func >>-<T, U>(a: [T], f: T -> [U]) -> [U] {
    return a.flatMap(f)
}

public func pure<T>(a: T) -> [T] {
    return [a]
}

extension Array {
    func apply<U>(fs: [T -> U]) -> [U] {
        return fs.flatMap { f in self.map(f) }
    }

    func flatMap<U>(f: T -> [U]) -> [U] {
        return reduce([]) { bs, a in bs + f(a) }
    }
}
