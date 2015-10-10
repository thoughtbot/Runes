import SwiftCheck
import XCTest
import Runes


class AsyncSpec: XCTestCase {
    func testFunctor() {
        // fmap id = id
        property("identity law") <- forAll { (x: AsyncOf<Int>) in
            let lhs = id <^> x.getAsync
            let rhs = x.getAsync

            return lhs == rhs
        }

        // fmap (f . g) = (fmap f) . (fmap g)
        property("function composition law") <- forAll { (o: AsyncOf<Int>, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>) in
            let f = fa.getArrow
            let g = fb.getArrow
            let x = o.getAsync

            let lhs = compose(f, g) <^> x
            let rhs = compose(curry(<^>)(f), curry(<^>)(g))(x)

            return lhs == rhs
        }
    }

    func testApplicative() {
        // pure id <*> v = v
        property("identity law") <- forAll { (x: AsyncOf<Int>) in
            let lhs = pure(id) <*> x.getAsync
            let rhs = x.getAsync

            return lhs == rhs
        }

        // pure f <*> pure x = pure (f x)
        property("homomorphism law") <- forAll { (x: Int, fa: ArrowOf<Int, Int>) in
            let f = fa.getArrow

            let lhs: (Int->Void)->Void = pure(f) <*> pure(x)
            let rhs: (Int->Void)->Void = pure(f(x))

            return rhs == lhs
        }

        // f <*> pure x = pure ($ x) <*> f
        property("interchange law") <- forAll { (x: Int, fa: AsyncOf<ArrowOf<Int, Int>>) in
            let f = {$0.getArrow} <^> fa.getAsync

            let lhs = f <*> pure(x)
            let rhs = pure({ $0(x) }) <*> f

            return lhs == rhs
        }

        // f <*> (g <*> x) = pure (.) <*> f <*> g <*> x
        property("composition law") <- forAll { (o: AsyncOf<Int>, fa: AsyncOf<ArrowOf<Int, Int>>, fb: AsyncOf<ArrowOf<Int, Int>>) in
            let x = o.getAsync
            let f = {$0.getArrow} <^> fa.getAsync
            let g = {$0.getArrow} <^> fb.getAsync

            let lhs = f <*> (g <*> x)
            let rhs = pure(curry(compose)) <*> f <*> g <*> x

            return lhs == rhs
        }
    }

    func testMonad() {
        // return x >>= f = f x
        property("left identity law") <- forAll { (x: Int, fa: ArrowOf<Int, Int>) in
            let f: Int -> (Int->Void)->Void = compose(pure, fa.getArrow)

            let lhs = pure(x) >>- f
            let rhs = f(x)

            return lhs == rhs
        }

        // m >>= return = m
        property("right identity law") <- forAll { (o: AsyncOf<Int>) in
            let x = o.getAsync

            let lhs = x >>- pure
            let rhs = x

            return lhs == rhs
        }

        // (m >>= f) >>= g = m >>= (\x -> f x >>= g)
        property("associativity law") <- forAll { (o: AsyncOf<Int>, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>) in
            let m = o.getAsync
            let f: Int -> (Int->Void)->Void = compose(pure, fa.getArrow)
            let g: Int -> (Int->Void)->Void = compose(pure, fb.getArrow)
            
            let lhs = (m >>- f) >>- g
            let rhs = m >>- { x in f(x) >>- g }
            
            return lhs == rhs
        }
    }
}
