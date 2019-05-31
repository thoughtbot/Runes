import XCTest
import SwiftCheck
import Runes

/// Generates an Result of arbitrary values of type A.
extension Result: Arbitrary where Success: Arbitrary, Failure: Arbitrary {
  /// Returns a generator of `Result`s of arbitrary `Success` values.
  public static var arbitrary : Gen<Result<Success, Failure>> {
    return Gen<Result<Success, Failure>>.frequency([
      (1, liftM(Result<Success, Failure>.failure, Failure.arbitrary)),
      (3, liftM(Result<Success, Failure>.success, Success.arbitrary)),
    ])
  }

  /// The default shrinking function for `Result`s of arbitrary `Success`s.
  public static func shrink(_ bl : Result<Success, Failure>) -> [Result<Success, Failure>] {
    switch bl {
    case let .success(val):
      return Success.shrink(val).map(Result<Success, Failure>.success)
    case let .failure(err):
      return Failure.shrink(err).map(Result<Success, Failure>.failure)
    }
  }
}

typealias ResultFunction = Result<ArrowOf<Int, Int>, String>

extension String: Error {}

class ResultSpec: XCTestCase {
  func testFunctor() {
    // fmap id = id
    property("identity law") <- forAll { (x: Result<Int, String>) in
      let identity: (Int) -> Int = id

      let lhs = identity <^> x
      let rhs = x

      return lhs == rhs
    }

     // fmap (f . g) = (fmap f) . (fmap g)
     property("function composition law") <- forAll { (x: Result<Int, String>, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>) in
       let f = fa.getArrow
       let g = fb.getArrow

       let lhs = f • g <^> x
       let rhs = (curry(<^>)(f) • curry(<^>)(g))(x)

       return lhs == rhs
     }
  }

  func testApplicative() {
    // pure id <*> v = v
    property("identity law") <- forAll { (x: Result<Int, String>) in
      let identity: (Int) -> Int = id

      let lhs = pure(identity) <*> x
      let rhs = x

      return lhs == rhs
    }

    // pure f <*> pure x = pure (f x)
    property("homomorphism law") <- forAll { (x: Int, fa: ArrowOf<Int, Int>) in
      let f = fa.getArrow

      let lhs: Result<Int, String> = pure(f) <*> pure(x)
      let rhs: Result<Int, String> = pure(f(x))

      return rhs == lhs
    }

    // f <*> pure x = pure ($ x) <*> f
    property("interchange law") <- forAll { (x: Int, fa: ResultFunction) in
      let f = fa.map { $0.getArrow }

      let lhs = f <*> pure(x)
      let rhs = pure({ $0(x) }) <*> f

      return lhs == rhs
    }

    // u *> v = pure (const id) <*> u <*> v
    property("interchange law - right sequence") <- forAll { (u: Result<Int, String>, v: Result<Int, String>) in
      let lhs = u *> v
      let rhs = pure(curry(const)(id)) <*> u <*> v

      return lhs == rhs
    }

    // u <* v = pure const <*> u <*> v
    property("interchange law - left sequence") <- forAll { (u: Result<Int, String>, v: Result<Int, String>) in
      let lhs = u <* v
      let rhs = pure(curry(const)) <*> u <*> v

      return lhs == rhs
    }

    // f <*> (g <*> x) = pure (.) <*> f <*> g <*> x
    property("composition law") <- forAll { (x: Result<Int, String>, fa: ResultFunction, fb: ResultFunction) in
      let f = fa.map { $0.getArrow }
      let g = fb.map { $0.getArrow }

      let lhs = f <*> (g <*> x)
      let rhs = pure(curry(•)) <*> f <*> g <*> x

      return lhs == rhs
    }
  }

  func testAlternative() {
    property("alternative operator - left empty") <- forAll { (x: Int) in
      let lhs: Result<Int, String> = .failure("msg") <|> pure(x)
      let rhs: Result<Int, String> = pure(x)

      return lhs == rhs
    }

    property("alternative operator - right empty") <- forAll { (x: Int) in
      let lhs: Result<Int, String> = pure(x) <|> .failure("msg")
      let rhs: Result<Int, String> = pure(x)

      return lhs == rhs
    }

    property("alternative operator - neither empty") <- forAll { (x: Int, y: Int) in
      let lhs: Result<Int, String> = pure(x) <|> pure(y)
      let rhs: Result<Int, String> = pure(x)

      return lhs == rhs
    }
  }

  func testMonad() {
    // return x >>= f = f x
    property("left identity law") <- forAll { (x: Int, fa: ArrowOf<Int, Int>) in
      let f: (Int) -> Result<Int, String> = pure • fa.getArrow

      let lhs = pure(x) >>- f
      let rhs = f(x)

      return lhs == rhs
    }

    // m >>= return = m
    property("right identity law") <- forAll { (x: Result<Int, String>) in
      let lhs = x >>- pure
      let rhs = x

      return lhs == rhs
    }

    // (m >>= f) >>= g = m >>= (\x -> f x >>= g)
    property("associativity law") <- forAll { (m: Result<Int, String>, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>) in
      let f: (Int) -> Result<Int, String> = pure • fa.getArrow
      let g: (Int) -> Result<Int, String> = pure • fb.getArrow

      let lhs = (m >>- f) >>- g
      let rhs = m >>- { x in f(x) >>- g }

      return lhs == rhs
    }

    // (f >=> g) >=> h = f >=> (g >=> h)
    property("left-to-right Kleisli composition of monads") <- forAll { (x: Int, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>, fc: ArrowOf<Int, Int>) in
      let f: (Int) -> Result<Int, String> = pure • fa.getArrow
      let g: (Int) -> Result<Int, String> = pure • fb.getArrow
      let h: (Int) -> Result<Int, String> = pure • fc.getArrow

      let lhs = (f >-> g) >-> h
      let rhs = f >-> (g >-> h)

      return lhs(x) == rhs(x)
    }

    // (f <=< g) <=< h = f <=< (g <=< h)
    property("right-to-left Kleisli composition of monads") <- forAll { (x: Int, fa: ArrowOf<Int, Int>, fb: ArrowOf<Int, Int>, fc: ArrowOf<Int, Int>) in
      let f: (Int) -> Result<Int, String> = pure • fa.getArrow
      let g: (Int) -> Result<Int, String> = pure • fb.getArrow
      let h: (Int) -> Result<Int, String> = pure • fc.getArrow

      let lhs = (f <-< g) <-< h
      let rhs = f <-< (g <-< h)

      return lhs(x) == rhs(x)
    }
  }
}
