import Quick
import Nimble
import Runes

private func pure<A>(a: A) -> [A] {
    return [a]
}

private func mAppend(x: String) -> [String] {
    return pure(append(x))
}

private func mPrepend(x: String) -> [String] {
    return pure(prepend(x))
}

class ArraySpec: QuickSpec {
    override func spec() {
        describe("Array") {
            describe("map") {
                // fmap id = id
                it("obeys the identity law") {
                    let array = ["fco"]
                    let lhs = id <^> array
                    let rhs = array

                    expect(lhs).to(equal(rhs))
                }

                // fmap (g . h) = (fmap g) . (fmap h)
                it("obeys the function composition law") {
                    let array = ["foo"]
                    let lhs = compose(append, prepend) <^> array
                    let rhs = compose(curry(<^>)(append), curry(<^>)(prepend))(array)

                    expect(lhs).to(equal(rhs))
                }
            }

            describe("apply") {
                // pure id <*> v = v
                it("obeys the identity law") {
                    let array = ["foo"]
                    let lhs = pure(id) <*> array
                    let rhs = array

                    expect(lhs).to(equal(rhs))
                }

                // pure f <*> pure x = pure (f x)
                it("obeys the homomorphism law") {
                    let foo = "foo"
                    let lhs = pure(append) <*> pure(foo)
                    let rhs = pure(append(foo))

                    expect(lhs).to(equal(rhs))
                }

                // u <*> pure y = pure ($ y) <*> u
                it("obeys the interchange law") {
                    let foo = "foo"
                    let lhs = pure(append) <*> pure(foo)
                    let rhs = pure({ $0(foo) }) <*> pure(append)

                    expect(lhs).to(equal(rhs))
                }

                // u <*> (v <*> w) = pure (.) <*> u <*> v <*> w
                it("obeys the composition law") {
                    let array = ["foo"]
                    let lhs = pure(append) <*> (pure(prepend) <*> array)
                    let rhs = pure(curry(compose)) <*> pure(append)  <*> pure(prepend) <*> array

                    expect(lhs).to(equal(rhs))
                }
            }

            describe("flatMap") {
                // return x >>= f = f x
                it("obeys the left identity law") {
                    let foo = "foo"
                    let lhs = pure(foo) >>- mAppend
                    let rhs = mAppend(foo)

                    expect(lhs).to(equal(rhs))
                }

                // m >>= return = m
                it("obeys the right identity law") {
                    let array = ["foo"]
                    let lhs = array >>- pure
                    let rhs = array

                    expect(lhs).to(equal(rhs))
                }

                // (m >>= f) >>= g = m >>= (\x -> f x >>= g)
                it("obeys the associativity law") {
                    let array = ["foo"]
                    let lhs = (array >>- mAppend) >>- mPrepend
                    let rhs = array >>- { x in mAppend(x) >>- mPrepend }

                    expect(lhs).to(equal(rhs))
                }
            }
        }
    }
}
