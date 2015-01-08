# Runes #

Indecipherable symbols that some people claim have actual meaning.

## Installation ##

### [Carthage](https://github.com/Carthage/Carthage) ##

`github "thoughtbot/runes"`

### [CocoaPods](http://cocoapods.org/) ###

_coming soon_

## What's included? ##

Importing Runes introduces 3 new operators:

- `<^>` (pronounced "map")
- `<*>` (pronounced "apply")
- `>>-` (pronounced "flatMap")

We also include default implementations for Optional with the following type signatures:

```swift
public func <^><T, U>(f: T -> U, a: T?) -> U?
public func <*><T, U>(f: (T -> U)?, a: T?) -> U?
public func >>-<T, U>(a: T?, f: T -> U?) -> U?
```
