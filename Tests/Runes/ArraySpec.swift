import XCTest
import SwiftCheck
import Mozart
import Runes

class ArraySpec: XCTestCase {
    func testFunctor() {
        // fmap id = id
        property("identity law") <- forAll { (xs: [Int]) in
            let lhs = id <^> xs
            let rhs = xs

            return lhs == rhs
        }

        // fmap (f . g) = (fmap f) . (fmap g)
        property("function composition law") <- forAll { (a: ArrayOf<Int>, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>) in
            let xs = a.getArray
            let f = fa.getArrow
            let g = fb.getArrow

            let lhs = f • g <^> xs
            let rhs = (curry(<^>)(f) • curry(<^>)(g))(xs)

            return lhs == rhs
        }
    }

    func testApplicative() {
        // pure id <*> x = x
        property("identity law") <- forAll { (xs: [Int]) in
            let lhs = pure(id) <*> xs
            let rhs = xs

            return lhs == rhs
        }

        // pure f <*> pure x = pure (f x)
        property("homomorphism law") <- forAll { (x: Int, fa: ArrowOf<Int, Int>) in
            let f = fa.getArrow

            let lhs: [Int] = pure(f) <*> pure(x)
            let rhs: [Int] = pure(f(x))

            return rhs == lhs
        }

        // f <*> pure x = pure ($ x) <*> f
        property("interchange law") <- forAll { (x: Int, fa: ArrayOf<ArrowOf<Int, Int>>) in
            let f = fa.getArray.map { $0.getArrow }

            let lhs = f <*> pure(x)
            let rhs = pure({ $0(x) }) <*> f

            return lhs == rhs
        }

        // f <*> (g <*> x) = pure (.) <*> f <*> g <*> x
        property("composition law") <- forAll { (a: ArrayOf<Int>, fa: ArrayOf<ArrowOf<Int, Int>>, fb: ArrayOf<ArrowOf<Int, Int>>) in
            let x = a.getArray
            let f = fa.getArray.map { $0.getArrow }
            let g = fb.getArray.map { $0.getArrow }

            let lhs = f <*> (g <*> x)
            let rhs = pure(curry(•)) <*> f <*> g <*> x

            return lhs == rhs
        }
    }

    func testMonad() {
        // return x >>= f = f x
        property("left identity law") <- forAll { (x: Int, fa: ArrowOf<Int, Int>) in
            let f: (Int) -> [Int] = pure • fa.getArrow

            let lhs = pure(x) >>- f
            let rhs = f(x)

            return lhs == rhs
        }

        // m >>= return = m
        property("right identity law") <- forAll { (x: [Int]) in
            let lhs = x >>- pure
            let rhs = x

            return lhs == rhs
        }

        // (m >>= f) >>= g = m >>= (\x -> f x >>= g)
        property("associativity law") <- forAll { (a: ArrayOf<Int>, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>) in
            let m = a.getArray
            let f: (Int) -> [Int] = pure • fa.getArrow
            let g: (Int) -> [Int] = pure • fb.getArrow

            let lhs = (m >>- f) >>- g
            let rhs = m >>- { x in f(x) >>- g }

            return lhs == rhs
        }

        // (f >=> g) >=> h = f >=> (g >=> h)
        property("left-to-right Kleisli composition of monads") <- forAll { (x: Int, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>, fc: ArrowOf<Int, Int>) in
            let f: (Int) -> [Int] = pure • fa.getArrow
            let g: (Int) -> [Int] = pure • fb.getArrow
            let h: (Int) -> [Int] = pure • fc.getArrow

            let lhs = (f >-> g) >-> h
            let rhs = f >-> (g >-> h)

            return lhs(x) == rhs(x)
        }

        // (f <=< g) <=< h = f <=< (g <=< h)
        property("right-to-left Kleisli composition of monads") <- forAll { (x: Int, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>, fc: ArrowOf<Int, Int>) in
            let f: (Int) -> [Int] = pure • fa.getArrow
            let g: (Int) -> [Int] = pure • fb.getArrow
            let h: (Int) -> [Int] = pure • fc.getArrow

            let lhs = (f <-< g) <-< h
            let rhs = f <-< (g <-< h)

            return lhs(x) == rhs(x)
        }
    }
}
