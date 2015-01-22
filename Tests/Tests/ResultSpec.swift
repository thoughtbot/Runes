import Fox
import LlamaKit
import Nimble
import NimbleFox
import Quick
import Runes

private func generateResult(block: Result<String, NSError> -> Bool) -> FOXGenerator {
    return forAll(FOXOptional(string())) { optString in
        switch optString as String? {
        case let .Some(s): return block(success(s))
        case .None: return block(failure(NSError(domain: "", code: 11, userInfo: nil)))
        }
    }
}

class ResultSpec: QuickSpec {
    override func spec() {
        describe("Result") {
            describe("map") {
                // fmap id = id
                it("obeys the identity law") {
                    let property = generateResult() { result in
                        let lhs = id <^> result
                        let rhs = result

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }

                // fmap (g . h) = (fmap g) . (fmap h)
                it("obeys the function composition law") {
                    let property = generateResult() { result in
                        let lhs = compose(append, prepend) <^> result
                        let rhs = compose(curry(<^>)(append), curry(<^>)(prepend))(result)

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }
            }

            describe("apply") {
                // pure id <*> v = v
                it("obeys the identity law") {
                    let property = generateResult() { result in
                        let lhs = pure(id) <*> result
                        let rhs = result

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }

                // pure f <*> pure x = pure (f x)
                it("obeys the homomorphism law") {
                    let property = generateString() { string in
                        let lhs: Result<String, NSError> = pure(append) <*> pure(string)
                        let rhs: Result<String, NSError> = pure(append(string))

                        return rhs == lhs
                    }

                    expect(property).to(hold())
                }

                // u <*> pure y = pure ($ y) <*> u
                it("obeys the interchange law") {
                    let property = generateString() { string in
                        let lhs: Result<String, NSError> = pure(append) <*> pure(string)
                        let rhs: Result<String, NSError> = pure({ $0(string) }) <*> pure(append)

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }

                // u <*> (v <*> w) = pure (.) <*> u <*> v <*> w
                it("obeys the composition law") {
                    let property = generateResult() { result in
                        let lhs = pure(append) <*> (pure(prepend) <*> result)
                        let rhs = pure(curry(compose)) <*> pure(append)  <*> pure(prepend) <*> result

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }
            }

            describe("flatMap") {
                // return x >>= f = f x
                it("obeys the left identity law") {
                    let property = generateString() { string in
                        let lhs: Result<String, NSError> = pure(string) >>- compose(append, pure)
                        let rhs: Result<String, NSError> = compose(append, pure)(string)

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }

                // m >>= return = m
                it("obeys the right identity law") {
                    let property = generateResult() { result in
                        let lhs = result >>- pure
                        let rhs = result

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }

                // (m >>= f) >>= g = m >>= (\x -> f x >>= g)
                it("obeys the associativity law") {
                    let property = generateResult() { result in
                        let lhs = (result >>- compose(append, pure)) >>- compose(prepend, pure)
                        let rhs = result >>- { x in compose(append, pure)(x) >>- compose(prepend, pure) }

                        return lhs == rhs
                    }

                    expect(property).to(hold())
                }
            }
        }
    }
}
