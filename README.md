<img src="https://raw.githubusercontent.com/thoughtbot/Runes/gh-pages/Logo.png" width="200" />

Indecipherable symbols that some people claim have actual meaning.

[![pod](https://img.shields.io/cocoapods/v/Runes.svg)](https://cocoapods.org/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Please see [the documentation] for [version compatibility] and [installation]
information.

[the documentation]: Documentation/
[version compatibility]: Documentation/version-compatibility.md
[installation]: Documentation/installation.md

## What's included? ##

Importing Runes introduces several new operators and one global function that
correspond to common Haskell typeclasses:

### Functor ###

- `<^>` (pronounced "map")

### Applicative Functor ###

- `<*>` (pronounced "apply")
- `<*` (pronounced "left sequence")
- `*>` (pronounced "right sequence")
- `pure` (pronounced "pure")

### Alternative ###

- `<|>` (pronounced "alternate")
- `empty` (pronounced "empty")

### Monad ###

- `>>-` (pronounced "flatMap") (left associative)
- `-<<` (pronounced "flatMap") (right associative)
- `>->` (pronounced "Monadic compose") (left associative)
- `<-<` (pronounced "Monadic compose") (right associative)

### Implementations ###

We also include default implementations for Optional and Array with the
following type signatures:

```swift
// Optional+Functor:
public func <^> <T, U>(f: T -> U, x: T?) -> U?

// Optional+Applicative:
public func <*> <T, U>(f: (T -> U)?, x: T?) -> U?
public func <* <T, U>(lhs: T?, rhs: U?) -> T?
public func *> <T, U>(lhs: T?, rhs: U?) -> U?
public func pure<T>(x: T) -> T?

// Optional+Alternative:
public func <|> <T>(lhs: T?, rhs: T?) -> T?
public func empty<T>() -> T?

// Optional+Monad:
public func >>- <T, U>(x: T?, f: T -> U?) -> U?
public func -<< <T, U>(f: T -> U?, x: T?) -> U?
public func >-> <T, U, V>(f: T -> U?, g: U -> V?) -> T -> V?
public func <-< <T, U, V>(f: U -> V?, g: T -> U?) -> T -> V?

// Array+Functor:
public func <^> <T, U>(f: T -> U, x: [T]) -> [U]

// Array+Applicative:
public func <*> <T, U>(fs: [T -> U], x: [T]) -> [U]
public func <* <T, U>(lhs: [T], rhs: [U]) -> [T]
public func *> <T, U>(lhs: [T], rhs: [U]) -> [U]
public func pure<T>(x: T) -> [T]

// Array+Alternative:
public func <|> <T>(lhs: [T], rhs: [T]) -> [T]
public func empty<T>() -> [T]

// Array+Monad:
public func >>- <T, U>(x: [T], f: T -> [U]) -> [U]
public func -<< <T, U>(f: T -> [U], x: [T]) -> [U]
public func >-> <T, U, V>(f: T -> [U], g: U -> [V]) -> T -> [V]
public func <-< <T, U, V>(f: U -> [V], g: T -> [U]) -> T -> [V]
```

## Contributing ##

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/Runes/graphs/contributors

## License ##

Runes is Copyright (c) 2015 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About ##

![thoughtbot](https://thoughtbot.com/logo.png)

Runes is maintained and funded by thoughtbot, inc. The names and logos for
thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or look at
our product [case studies] and [hire us][hire] to help build your iOS app.

[community]: https://thoughtbot.com/community?utm_source=github
[case studies]: https://thoughtbot.com/ios?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
