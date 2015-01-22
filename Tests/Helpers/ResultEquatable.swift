import LlamaKit

func ==<T, E where T: Equatable, E: Equatable>(lhs: Result<T, E>, rhs: Result<T, E>) -> Bool {
    switch (lhs, rhs) {
    case let (.Success(l), .Success(r)): return l.unbox == r.unbox
    case let (.Failure(l), .Failure(r)): return l.unbox == r.unbox
    default: return false
    }
}