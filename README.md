# Runes #

Indecipherable symbols that some people claim have actual meaning.

## Installation ##

### [Carthage](https://github.com/Carthage/Carthage) ##

`github "thoughtbot/runes"`

### [CocoaPods](http://cocoapods.org/) ###

_coming soon_

## What's included? ##

Importing Runes introduces 3 new operators and one global function:

- `<^>` (pronounced "map")
- `<*>` (pronounced "apply")
- `>>-` (pronounced "flatMap")
- `pure` (pronounced "pure")

We also include default implementations for Optional and Array with the
following type signatures:

```swift
// Optional:
public func <^><T, U>(f: T -> U, a: T?) -> U?
public func <*><T, U>(f: (T -> U)?, a: T?) -> U?
public func >>-<T, U>(a: T?, f: T -> U?) -> U?
public func pure<T>(a: T) -> T?

// Array:
public func <^><T, U>(f: T -> U, a: [T]) -> [U]
public func <*><T, U>(fs: [T -> U], a: [T]) -> [U]
public func >>-<T, U>(a: [T], f: T -> [U]) -> [U]
public func pure<T>(a: T) -> [T]
```
