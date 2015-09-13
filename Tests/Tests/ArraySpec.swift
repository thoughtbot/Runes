import SwiftCheck
import XCTest
import Runes

class ArraySpec: XCTestCase {
    func testFunctor() {
        // fmap id = id
        property("identity law") <- forAll { (array: [String]) in
            let lhs = id <^> array
            let rhs = array

            return lhs == rhs
        }

        // fmap (g . h) = (fmap g) . (fmap h)
        property("function composition law") <- forAll { (array: [String]) in
            let lhs = compose(append, prepend) <^> array
            let rhs = compose(curry(<^>)(append), curry(<^>)(prepend))(array)

            return lhs == rhs
        }
    }

    func testApplicative() {
        // pure id <*> v = v
        property("identity law") <- forAll { (array: [String]) in
            let lhs = pure(id) <*> array
            let rhs = array

            return lhs == rhs
        }

        // pure f <*> pure x = pure (f x)
        property("homomorphism law") <- forAll { (string: String) in
            let lhs: [String] = pure(append) <*> pure(string)
            let rhs: [String] = pure(append(string))

            return rhs == lhs
        }

        // u <*> pure y = pure ($ y) <*> u
        property("interchange law") <- forAll { (string: String) in
            let lhs: [String] = pure(append) <*> pure(string)
            let rhs: [String] = pure({ $0(string) }) <*> pure(append)

            return lhs == rhs
        }

        // u <*> (v <*> w) = pure (.) <*> u <*> v <*> w
        property("composition law") <- forAll { (array: [String]) in
            let lhs = pure(append) <*> (pure(prepend) <*> array)
            let rhs = pure(curry(compose)) <*> pure(append)  <*> pure(prepend) <*> array

            return lhs == rhs
        }
    }

    func testMonad() {
        // return x >>= f = f x
        property("left identity law") <- forAll { (string: String) in
            let lhs: [String] = pure(string) >>- compose(append, pure)
            let rhs: [String] = compose(append, pure)(string)

            return lhs == rhs
        }

        // m >>= return = m
        property("right identity law") <- forAll { (array: [String]) in
            let lhs = array >>- pure
            let rhs = array

            return lhs == rhs
        }

        // (m >>= f) >>= g = m >>= (\x -> f x >>= g)
        property("associativity law") <- forAll { (array: [String]) in
            let lhs = (array >>- compose(append, pure)) >>- compose(prepend, pure)
            let rhs = array >>- { x in compose(append, pure)(x) >>- compose(prepend, pure) }

            return lhs == rhs
        }
    }
}
