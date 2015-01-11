func <^> <S: SequenceType, A, B where S.Generator.Element == A> (f: A -> B, source: S) -> [B] {
    return map(source, f)
}

func <*> <A, B> (fs: [A -> B], source: [A]) -> [B] {
    return fs >>- { f in f <^> source }
}

func >>- <S: SequenceType, T: SequenceType, A, B where S.Generator.Element == A, T.Generator.Element == B> (source: S, f: A -> T) -> [B] {
    return reduce(source, []) { dest, a in dest + f(a) }
}
