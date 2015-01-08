public func <^><T, U>(f: T -> U, a: T?) -> U? {
    return a.map(f)
}

public func <*><T, U>(f: (T -> U)?, a: T?) -> U? {
    return a.apply(f)
}

public func >>-<T, U>(a: T?, f: T -> U?) -> U? {
    return a.flatMap(f)
}

extension Optional {
    func apply<U>(f: (T -> U)?) -> U? {
        switch (self, f) {
        case let (.Some(x), .Some(fx)): return fx(x)
        default: return .None
        }
    }

    func flatMap<U>(f: T -> U?) -> U? {
        switch self {
        case let .Some(x): return f(x)
        default: return .None
        }
    }
}
