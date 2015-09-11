import func SwiftCheck.property
import func SwiftCheck.forAll
import func SwiftCheck.<-
import XCTest
import Runes

class OptionalSpec: XCTestCase {
    func testFunctor() {
        // fmap id = id
        property("identity law") <- forAll { (optional: String?) in
            let lhs = id <^> optional
            let rhs = optional

            return lhs == rhs
        }

        // fmap (g . h) = (fmap g) . (fmap h)
        property("function composition law") <- forAll { (optional: String?) in
            let lhs = compose(append, prepend) <^> optional
            let rhs = compose(curry(<^>)(append), curry(<^>)(prepend))(optional)

            return lhs == rhs
        }
    }

    func testApplicative() {
        // pure id <*> v = v
        property("identity law") <- forAll { (optional: String?) in
            let lhs = pure(id) <*> optional
            let rhs = optional

            return lhs == rhs
        }

        // pure f <*> pure x = pure (f x)
        property("homomorphism law") <- forAll { (string: String) in
            let lhs: String? = pure(append) <*> pure(string)
            let rhs: String? = pure(append(string))

            return rhs == lhs
        }

        // u <*> pure y = pure ($ y) <*> u
        property("interchange law") <- forAll { (string: String) in
            let lhs: String? = pure(append) <*> pure(string)
            let rhs: String? = pure({ $0(string) }) <*> pure(append)

            return lhs == rhs
        }

        // u <*> (v <*> w) = pure (.) <*> u <*> v <*> w
        property("compospropertyion law") <- forAll { (optional: String?) in
            let lhs = pure(append) <*> (pure(prepend) <*> optional)
            let rhs = pure(curry(compose)) <*> pure(append)  <*> pure(prepend) <*> optional

            return lhs == rhs
        }
    }

    func testMonad() {
        // return x >>= f = f x
        property("left identity law") <- forAll { (string: String) in
            let lhs: String? = pure(string) >>- compose(append, pure)
            let rhs: String? = compose(append, pure)(string)

            return lhs == rhs
        }

        // m >>= return = m
        property("right identity law") <- forAll { (optional: String?) in
            let lhs = optional >>- pure
            let rhs = optional

            return lhs == rhs
        }

        // (m >>= f) >>= g = m >>= (\x -> f x >>= g)
        property("associativity law") <- forAll { (optional: String?) in
            let lhs = (optional >>- compose(append, pure)) >>- compose(prepend, pure)
            let rhs = optional >>- { x in compose(append, pure)(x) >>- compose(prepend, pure) }

            return lhs == rhs
        }
    }
}
