precedencegroup MonadicPrecedenceRight {
    associativity: right
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

precedencegroup MonadicPrecedenceLeft {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

precedencegroup AlternativePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: ComparisonPrecedence
}

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: AlternativePrecedence
    lowerThan: NilCoalescingPrecedence
}

precedencegroup ApplicativeSequencePrecedence {
    associativity: left
    higherThan: ApplicativePrecedence
    lowerThan: NilCoalescingPrecedence
}

/**
map a function over a value with context

Expected function type: `(a -> b) -> f a -> f b`
Haskell `infixl 4`
*/
infix operator <^> : ApplicativePrecedence

/**
apply a function with context to a value with context

Expected function type: `f (a -> b) -> f a -> f b`
Haskell `infixl 4`
*/
infix operator <*> : ApplicativePrecedence

/**
sequence actions, discarding right (value of the second argument)

Expected function type: `f a -> f b -> f a`
Haskell `infixl 4`
*/
infix operator <* : ApplicativeSequencePrecedence

/**
sequence actions, discarding left (value of the first argument)

Expected function type: `f a -> f b -> f b`
Haskell `infixl 4`
*/
infix operator *> : ApplicativeSequencePrecedence

/**
an associative binary operation

Expected function type: `f a -> f a -> f a`
Haskell `infixl 3`
*/
infix operator <|> : AlternativePrecedence

/**
map a function over a value with context and flatten the result

Expected function type: `m a -> (a -> m b) -> m b`
Haskell `infixl 1`
*/
infix operator >>- : MonadicPrecedenceLeft

/**
map a function over a value with context and flatten the result

Expected function type: `(a -> m b) -> m a -> m b`
Haskell `infixr 1`
*/
infix operator -<< : MonadicPrecedenceRight

/**
compose two functions that produce results in a context,
from left to right, returning a result in that context

Expected function type: `(a -> m b) -> (b -> m c) -> a -> m c`
Haskell `infixr 1`
*/
infix operator >-> : MonadicPrecedenceRight

/**
compose two functions that produce results in a context,
from right to left, returning a result in that context

like `>->`, but with the arguments flipped

Expected function type: `(b -> m c) -> (a -> m b) -> a -> m c`
Haskell `infixr 1`
*/
infix operator <-< : MonadicPrecedenceRight
