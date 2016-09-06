import Runes

precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: RunesApplicativeSequencePrecedence
}

infix operator •: CompositionPrecedence

func • <A, B, C> (f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { x in f(g(x)) }
}
